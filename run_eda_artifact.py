import argparse
from accelpy.eda_artifact import classify_noninteractive

parser = argparse.ArgumentParser(
  description="Run the artifact detection classifier on a dataset.",
  formatter_class=argparse.ArgumentDefaultsHelpFormatter
)
parser.add_argument('file_path', help='The input data file (a csv)')
parser.add_argument('output_path', help='Path where the results will be saved')
parser.add_argument('--classifier', choices=['Binary', 'Multiclass', 'Both'],
                    help='Which classifier to use to label artifacts',
                    default='Binary')

args = parser.parse_args()

classify_noninteractive(file_path=args.file_path,
                        output_path=args.output_path,
                        classifier=args.classifier)
  
