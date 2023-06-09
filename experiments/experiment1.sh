# Script for Experiment 2.1 (Amsterdam)
echo "Starting Experiment 1 (Amerika op Amsterdam)"

experiment="001"
# the paper this experiment is being run for
paper="Bachelorproef"
# session name to uniquely identify an experiment run
session_name="1"
# city name
city="amsterdam"
# label types
labels=("curb_ramp" "missing_curb_ramp" "obstacle" "surface_problem")
# path to train/test CSV data
csv_base_path="../datasets/"
# test set CSV filename
test_set_csv="amsterdam_crop_info.csv"
# path to train/test image data
image_base_path="../panos/"
# name of model architecture
model_name="hrnet"
# save path for model weights
model_save_folder="../models/"
# save path the visualizations
visualizations_path="../visualizations/"
# number of epochs for training
num_epochs="10"
# crop size
crop_size="1000"
# number of plots for mistake visualization
num_plots="5"

echo "initializing..."
mkdir -p "$csv_base_path/tmp/$city"
for label in {1..4}; do
  # binarize test set
  python ../utils/dataset_creator.py "binarize" "$csv_base_path/$paper/$city/$test_set_csv" "$label" "$csv_base_path/tmp/$city/test_set_${labels[$label - 1]}.csv"
done

# make relevant directories
mkdir -p "$model_save_folder/$experiment/$city"
mkdir -p "$visualizations_path/$experiment/$city"

for label in {1..4}; do
  #echo "training label ${labels[$label - 1]} classifier on all cities..."
  # compose list of train set csvs to combine

  # train model on combined train set
 # python ../train.py "${experiment}_${session_name}_${labels[$label - 1]}" "$image_base_path" "$csv_base_path/tmp/$city/train_set_${labels[$label - 1]}.csv" "$model_name" "$model_save_folder/$experiment/$city" "$num_epochs" "$crop_size"
  echo "testing label ${labels[$label - 1]} classifier on $city..."
  # evaluate model on each city
  python ../eval.py ${experiment}_${session_name}_${city} ${experiment}_${session_name}_${labels[$label - 1]} $image_base_path $csv_base_path/"tmp/"$city/"test_set_"${labels[$label - 1]}".csv" $model_name $model_save_folder/$experiment/$city/${labels[$label - 1]} $visualizations_path/$experiment/$city $crop_size
  # analyze results
  python ../visualization_utils/analyze_results.py "${experiment}_${session_name}_${labels[$label - 1]}" "$model_save_folder/$experiment/$city/${labels[$label - 1]}" "$visualizations_path/$experiment/$city"
  # visualize mistakes
  python ../visualization_utils/visualize_mistakes.py "${experiment}_${session_name}_${labels[$label - 1]}" "$image_base_path" "$visualizations_path/$experiment/$city" "$crop_size" "$num_plots"
done

#python ../visualization_utils/plot_pr_roc.py ${experiment}_${session_name}_${city} $visualizations_path/$experiment/$city

echo "Finished Experiment 2.1!"
