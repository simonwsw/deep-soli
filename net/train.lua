require 'class'

local Train = torch.class('Train')

function Train:__init(labelSize, useCuda, useCudnn)
  -- require and cuda support
  require 'net.stat'
  self.useCuda = useCuda
  self.useCudnn = useCudnn
  if useCuda then
    require 'cutorch'
    require 'cunn'
  end
  -- other parameters
  self.labelSize = labelSize
end

-- one step of evaluate to all data
function Train:epochEval(batchSize, maxSeq)
  local stat = Stat(self.labelSize, batchSize, maxSeq)
  for b = 1, math.floor(#self.evalData.seqList / batchSize) do
    -- load data, start evaluating, depends on net type
    local inputs, targets = self.evalData:loadBatch(b, batchSize, maxSeq)
    local outputs = self:batchEval(b, inputs)
    -- update confusion matrix
    stat:updateStat(outputs, targets)
  end
  return stat:print('eval')
end

-- convert to cuda
function Train:convertCuda(list)
  if self.cuda then
    -- convert table one by one to cuda
    for l = 1, #list do
      list[l] = list[l]:cuda()
    end
    return list
  else
    return list
  end
end

function Train:train(batchSize, maxSeq)
  -- evaluate by epoch
  self:epochEval(batchSize, maxSeq)
  print('Finished')
end
