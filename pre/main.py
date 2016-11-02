import argparse

from seq import Seq

# call different method depends on op
def main(op, file_dir, target_dir, num_channel=1, redo=False,
        origin_size=32, out_size=32):
    s = Seq()

    if op == 'image':
        s.generate_image(file_dir, target_dir, num_channel,
            origin_size, out_size, redo)
    elif op == 'clean':
        s.clean_image(file_dir)
    elif op == 'mean':
        s.generate_mean(file_dir, target_dir, num_channel, out_size)
    else:
        raise NameError('The operation type {} is undefined'.format(op))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate image")
    parser.add_argument('--op', type=str)
    parser.add_argument('--file', type=str)
    parser.add_argument('--target', type=str)
    parser.add_argument('--channel', type=int)
    parser.add_argument('--redo',  action='store_true')
    parser.add_argument('--originsize', type=int)
    parser.add_argument('--outsize', type=int)

    args = parser.parse_args()

    main(args.op, args.file, args.target, args.channel, args.redo,
        args.originsize, args.outsize)
