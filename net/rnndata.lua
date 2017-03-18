require 'class'

require 'net.data'
require 'net.imageseq'

local RnnData = torch.class('RnnData', 'Data')

function RnnData:__init(fileDir, listFile, meanFile, listType,
    inputSize, inputCh, labelSize, dataSize, dataCh, ch, useCuda)
  Data.__init(self, fileDir, listFile, meanFile, listType,
    inputSize, inputCh, labelSize, dataSize, dataCh, ch, useCuda)
end

function RnnData:frameSeq(seq, maxSeq)
  -- load label for each frame, label is 1-based, f is frame id
  -- offset introduce zero paddings at the beginning of the sequence
  local frames = {}
  if #seq.info < maxSeq then
    local offset = maxSeq - #seq.info
    for f = 1, #seq.info do
      frames[offset + f] = f
    end
  else
    for f = 1, maxSeq do
      frames[f] = math.floor(f * (#seq.info / maxSeq))
    end
  end
  return frames
end

-- load batch to tensor
function RnnData:loadBatch(batchNum, batchSize, maxSeq)
  local inputs, targets = self:initBatch(batchSize, maxSeq)
  -- load data into inputs and targets
  local batchStart = (batchNum - 1) * batchSize
  for b = 1, batchSize do
    -- get seq info
    local seq
    seq = ImageSeq(self.seqList[batchStart + b], self.mean,
      self.dataSize, self.dataCh, self.ch, self.useCuda)
    -- generate frame sequence
    local frames = self:frameSeq(seq, maxSeq)
    for i, v in pairs(frames) do
      inputs[i][b] = seq:getFrame(v)
      targets[i][b] = seq.info[v]
    end
  end

  return inputs, targets
end
