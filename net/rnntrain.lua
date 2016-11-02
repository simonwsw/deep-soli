require 'class'

require 'net.train'
require 'net.util'

local RnnTrain = torch.class('RnnTrain', 'Train')

function RnnTrain:__init(fileDir, listFile, meanFile,
    inputSize, inputCh, labelSize, dataSize, dataCh, ch,
    loadFile, useCuda, useCudnn)
  -- call base train constructor
  Train.__init(self, labelSize, useCuda, useCudnn)
  -- load data
  require 'net.rnndata'
  self.evalData = RnnData(fileDir, listFile, meanFile, 'eval',
    inputSize, inputCh, labelSize, dataSize, dataCh, ch, useCuda)
  print(string.format('[eval] data with %d seq', #self.evalData.seqList))
  -- build net
  local netObject
  require 'net.uninet'
  netObject = UniNet(useCuda, useCudnn)
  self.net = netObject:loadNet(loadFile)
end

function RnnTrain:batchEval(b, inputs)
  -- evaluate forward as whole sequence
  self.net:evaluate()
  local outputs = self.net:forward(self:convertCuda(inputs))
  self.net:forget()
  return outputs
end
