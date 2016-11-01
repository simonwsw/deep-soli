#include <vector>
#include <string>

// boost options
#include <boost/program_options.hpp>
namespace po = boost::program_options;

#include "seq.hpp"

int main(int argc, char *argv[]) {
	try {
		// generate argument parser
		po::options_description desc("Image: allowed options");
		desc.add_options()
			("help", "Print help messages")
			("source", po::value<std::string>(), "h5 source file")
			("target", po::value<std::string>(), "Flow target directory")
			("channel", po::value<int>(), "Channel number")
			("origin", po::value<int>(), "Origin size")
			("out", po::value<int>(), "Output size")
			("label", po::value<bool>(), "Print label in output file name")
			("bound", po::value<double>(), "Bound for normalization");

		po::variables_map vm;
		po::store(po::parse_command_line(argc, argv, desc), vm);
		po::notify(vm);

		std::string source, target;
		int numChannel = 1, origin = 32, out = 32;
		bool label = false;
		double bound = 15.0;

		// assign argument to local variables
		if (vm.count("help")) {
			std::cout << "Image" << std::endl << desc << std::endl;
			return 0;
		} else {
			if (vm.count("source")) source = vm["source"].as<std::string>();
			if (vm.count("target")) target = vm["target"].as<std::string>();
			if (vm.count("channel")) numChannel = vm["channel"].as<int>();
			if (vm.count("origin")) origin = vm["origin"].as<int>();
			if (vm.count("out")) out = vm["out"].as<int>();
			if (vm.count("label")) label = vm["label"].as<bool>();
			if (vm.count("bound")) bound = vm["bound"].as<double>();

			// generate flow for different channels
			Seq seq = Seq(source, target, numChannel, label);
			for (int i = 0; i < numChannel; i++) {
				seq.flow(i, origin, origin, out, out, bound);
			}
		}
	} catch (std::exception& e) {
			std::cerr << "Error: " << e.what() << std::endl;
			return 1;
	} catch (...) {
			std::cerr << "Exception of unknown type" << std::endl;
			return 1;
	}

	return 0;
}
