require 'net.util'

-- parse cmd parameters
local cmd = torch.CmdLine()

cmd:option('--file', '../collect_image/origin_trans', 'Image dir')
cmd:option('--list', 'tmp/file.json', 'List file json')
cmd:option('--load', '', 'Load model file')

cmd:option('--inputsize', 32, 'Input size')
cmd:option('--inputch', 4, 'Input channel')
cmd:option('--label', 3, 'Label size')

cmd:option('--datasize', 32, 'Data size')
cmd:option('--datach', 4, 'Data channel (number of stack)')

cmd:option('--batch', 4, 'Batch size')
cmd:option('--maxseq', 40, 'Sequence length')

cmd:option('--cuda', false, 'Use CUDA')
cmd:option('--cudnn', false, 'Use CUDNN')
local opt = cmd:parse(arg or {})

--- other parameters
local meanFile = 'tmp/mean_32.mat'
local ch = 1

-- default tensor
if opt.cuda then
  require 'cutorch'
  require 'cunn'
  torch.setdefaulttensortype('torch.CudaTensor')
else
  torch.setdefaulttensortype('torch.FloatTensor')
end

-- train net, switch train type
local trainObject
require 'net.rnntrain'
trainObject = RnnTrain(opt.file, opt.list, meanFile,
  opt.inputsize, opt.inputch, opt.label,
  opt.datasize, opt.datach, ch,
  opt.load, opt.cuda, opt.cudnn)

trainObject:train(opt.batch, opt.maxseq)
