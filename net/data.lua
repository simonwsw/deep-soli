require 'class'
require 'paths'
require 'mattorch'
local json = require 'lunajson'

require 'net.util'

local Data = torch.class('Data')

function Data:__init(fileDir, listFile, meanFile, listType,
    inputSize, inputCh, labelSize, dataSize, dataCh, ch, useCuda)
  self.seqList = self:getSeq(fileDir, listFile, listType)
  self.mean = self:loadMean(meanFile)
  self.inputSize = inputSize
  self.inputCh = inputCh
  self.labelSize = labelSize
  self.dataSize = dataSize
  self.dataCh = dataCh
  self.ch = ch
  self.useCuda = useCuda
end

function Data:getSeq(fileDir, listFile, listType)
  -- read file into json
  local f = io.open(listFile, 'rb')
  local jsonString = f:read('*all')
  local jsonObject = json.decode(jsonString)
  f:close()
  -- arrange it according to different label
  local seqList = {}
  for i in pairs(jsonObject[listType]) do
    seqList[#seqList + 1] = paths.concat(fileDir, jsonObject[listType][i])
  end
  return seqList
end

-- random shuffle a list
function Data:shuffleList(list)
  local n, random = #list, math.random
  for i = 1, n do
    local j, k = random(n), random(n)
    list[j], list[k] = list[k], list[j]
  end
  return list
end

-- load mat mean file
function Data:loadMean(meanFile)
  return mattorch.load(meanFile)
end

function Data:initBatch(batchSize, seqLength)
  -- initialize inputs and targets, zero mask will ignore null target
  local inputs, targets = {}, {}
  for l = 1, seqLength do
    -- init with 4d data (cnn and uni)
    inputs[l] = torch.Tensor(batchSize,
      self.inputCh, self.inputSize, self.inputSize):zero()
    targets[l] = torch.Tensor(batchSize):fill(self.labelSize)
  end
  return inputs, targets
end
