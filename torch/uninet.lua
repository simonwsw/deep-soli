require 'class'
require 'rnn'

require 'torch.net'

local UniNet = torch.class('UniNet', 'Net')

function UniNet:__init(useCuda, useCudnn)
  Net.__init(self, useCuda, useCudnn)
end
