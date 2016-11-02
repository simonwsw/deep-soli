require 'class'
require 'paths'
require 'image'
local json = require 'lunajson'

require 'net.util'

local Seq = torch.class('Seq')

function Seq:__init(seqName, mean, dataSize, dataCh, ch, useCuda)
  -- load info
  self.name = seqName
  self.mean = mean
  self.dataSize = dataSize
  self.dataCh = dataCh
  self.ch = ch
  self.useCuda = useCuda
end
