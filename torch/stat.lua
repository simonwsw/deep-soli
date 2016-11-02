require 'class'
local json = require 'lunajson'

local Stat = torch.class('Stat')

function Stat:__init(labelSize, batchSize, maxSeq)
  self.labelSize = labelSize
  self.batchSize = batchSize
  self.maxSeq = maxSeq
  -- init confusion matrix (correct label (size) * predict label (size))
  self.confus = self:initMat(labelSize, labelSize)
end

function Stat:initMat(height, width)
  local mat = {}
  for h = 1, height do
    mat[h] = {}
    for w = 1, width do
      mat[h][w] = 0
    end
  end
  return mat
end

function Stat:updateStat(outputs, targets)
  -- calculate one sequence by one sequence
  for o = 1, #outputs do
    local _, indices = torch.max(outputs[o], 2)
    for b = 1, self.batchSize do
      local right, pred = targets[o][b], indices[b][1]
      -- update confusion matrix
      self.confus[right][pred] = self.confus[right][pred] + 1
    end
  end
end

function Stat:sum(list, length)
  local result = 0
  -- ignore null label in sum
  for i = 1, length do
    result = result + list[i]
  end
  return result
end

-- calculate per label stat
function Stat:calPerLabel()
  local right, count = {}, {}
  -- iterate for all label
  for l = 1, self.labelSize do
    right[l] = self.confus[l][l]
    count[l] = self:sum(self.confus[l], #self.confus[l])
  end
  return right, count
end

-- print matrix
function Stat:printMat(str, right, count, matRight, matCount)
  for l = 1, #right do
    if count[l] > 0 then
      local accLine = right[l] * 100 / count[l]
      io.write(string.format('    %s %02d: %02.0f [', str, l, accLine))
      for ll = 1, #matRight[1] do
        -- print each element depends on the type and value
        if type(matCount[l]) == 'number' and matCount[l] > 0 then
          local acc = matRight[l][ll] * 100 / matCount[l]
          io.write(string.format(' %02.0f ', acc))
        else
          io.write(' -- ')
        end
      end
      io.write(']\n')
    else
      io.write(string.format('    %s %02d: --\n', str, l))
    end
  end
end

function Stat:print(type)
  local right, count = self:calPerLabel()
  -- calculate sum of label
  local accEpoch = self:sum(right, #right - 1) / self:sum(count, #count - 1)
  io.write(string.format('[%s] accuracy %f\n', type, accEpoch))
  -- print per label and confusion matrix
  self:printMat('label', right, count, self.confus, count)
  -- return accuracy for lr update
  return accEpoch
end
