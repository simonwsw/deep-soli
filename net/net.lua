require 'class'

local Net = torch.class('Net')

function Net:__init(useCuda, useCudnn)
  -- cuda support
  self.useCuda = useCuda
  self.useCudnn = useCudnn
  if self.useCuda then
    require 'cutorch'
    require 'cunn'
    if self.useCudnn then
      require 'cudnn'
    end
  end
end

-- load already exist net
function Net:loadNet(loadFile)
  print('[net] loading model ' .. loadFile)
  net = torch.load(loadFile)
  print(net)
  return net
end

-- cuda and cudnn support
function Net:cudaNet(net)
  if self.useCuda then
    print('[net] with cuda')
    net = net:cuda()
    if self.useCudnn then
      print('[net] with cudnn')
      cudnn.convert(net, cudnn)
    end
  else
    print('[net] without cuda')
  end
  print(net)
  return net
end
