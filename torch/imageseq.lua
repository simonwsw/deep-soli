require 'class'
require 'paths'
require 'image'
local json = require 'lunajson'

require 'net.seq'
require 'net.util'

local ImageSeq = torch.class('ImageSeq', 'Seq')

function ImageSeq:__init(seqName, mean, dataSize, dataCh, ch, useCuda)
  Seq.__init(self, seqName, mean, dataSize, dataCh, ch, useCuda)
  self.info = self:getSeqInfo()
  -- load frame depends on image type, lib image support only float tensor
  -- reset tensor type back to float tensor when using cuda
  torch.setdefaulttensortype('torch.FloatTensor')
  self.imageFrame = self:loadFrame('image')
  -- set tensor type back to cuda tensor when using cuda
  if self.useCuda then
    torch.setdefaulttensortype('torch.CudaTensor')
  end
end

-- read label file
function ImageSeq:getSeqInfo()
  -- read file into json
  local f = io.open(paths.concat(self.name, 'label.json'), 'rb')
  local jsonString = f:read('*all')
  local jsonObject = json.decode(jsonString)
  f:close()
  -- convert into num based index, 0-based to 1-based
  -- label is also 1-based: 0-4 => 1-5
  local seqInfo = {}
  for i in pairs(jsonObject) do
    seqInfo[i + 1] = jsonObject[i] + 1
  end
  return seqInfo
end

function ImageSeq:loadFrame(imageType)
  local frame = {}
  local m = self.mean[string.format('ch%d_image', self.ch)]
    :permute(3, 2, 1) -- the matlab order is reversed
  -- access each frame, 1-based to 0-based image name
  for f = 1, #self.info do
    local name = string.format('ch%d_%d_image.jpg', self.ch, f - 1)
    -- for image tensor, first map from 0-1 to 0-255,
    -- then minus mean (also in 0-255)
    frame[#frame + 1] = (image.load(paths.concat(self.name, name), 1) * 256) - m
  end
  return frame
end

function ImageSeq:getImage(f)
  -- appending later frames
  local mat = self.imageFrame[f]
  for i = 1, self.dataCh - 1 do
    mat = torch.cat(mat, self.imageFrame[math.min(#self.info, f + i)], 1)
  end
  return mat
end

function ImageSeq:getFrame(f)
  -- load data depends on image or flow
  local matrix = self:getImage(f)
  return matrix
end
