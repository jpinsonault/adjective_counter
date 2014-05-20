import argeparse


def main(args):
	pass


def parse_args():
	parser = argparse.ArgumentParser()
    parser.add_argument('input_string')

    return parser.parse_args()


if __name__ == '__main__':
	main(parse_args())