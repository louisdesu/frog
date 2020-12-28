import argparse
from accelpy.eda_peak import find_peaks_noninteractive

parser = argparse.ArgumentParser(
  description="Run the peak detection algorithm on a dataset.",
  formatter_class=argparse.ArgumentDefaultsHelpFormatter
)
parser.add_argument('file_path', help='The input data file (a csv)')
parser.add_argument('output_path', help='Path where the results will be saved')
parser.add_argument('--threshold', type=float, default=0.02,
                    help='the minimum uS change required to register as a peak')
parser.add_argument('--offset', type=int, default=1,
                    help='the number of rising samples and falling samples' 
                         ' after a peak needed to be counted as a peak')
parser.add_argument('--max_rise_time', type=int, default=4,
                    help='maximum number of seconds before the apex of a peak'
                         ' that is the "start" of the peak')
parser.add_argument('--max_decay_time', type=int, default=4,
                    help='maximum number of seconds after the apex of a peak '
                         'that is the "rec.t/2" of the peak, 50% of amplitude')

args = parser.parse_args()

# TODO: is it possible to get the plot option working? Might have to
#   save the plot as an image file.
find_peaks_noninteractive(file_path=args.file_path,
                          output_path=args.output_path,
                          threshold=args.threshold,
                          offset=args.offset,
                          max_rise_time=args.max_rise_time,
                          max_decay_time=args.max_decay_time)
