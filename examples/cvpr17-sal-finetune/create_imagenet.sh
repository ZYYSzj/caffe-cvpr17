#!/usr/bin/env sh
# Create the imagenet lmdb inputs
# N.B. set the path to the imagenet train + val data dirs
set -e

EXAMPLE=examples/imagenet
TOOLS=build/tools

TRAIN_DATA_ROOT=/home/lijun/Research/DataSet/ILSVRC2014/ILSVRC2014_DET/image/ILSVRC2014_DET_train/
TRAIN_LIST_PATH=/home/lijun/Research/DataSet/ILSVRC2014/ILSVRC2014_DET/
MAP_ROOT=/home/lijun/Research/DataSet/ILSVRC2014/ILSVRC2014_DET/sal_map_2_png_merged/sal_map_2_png/ILSVRC2014_DET_train/
#VAL_DATA_ROOT=/home/lijun/Research/DataSet/ILSVRC2014/ILSVRC2014_DET/image/ILSVRC2013_DET_val/
#LMDB_PATH=/home/lijun/Research/DataSet/ILSVRC2014/ILSVRC2014_DET/
LMDB_PATH=/home/lijun/Research/DataSet/ILSVRC2014/ILSVRC2014_DET/



# Set RESIZE=true to resize the images to 256x256. Leave as false if images have
# already been resized using another tool.
RESIZE=true
if $RESIZE; then
  RESIZE_HEIGHT=256
  RESIZE_WIDTH=256
else
  RESIZE_HEIGHT=0
  RESIZE_WIDTH=0
fi

if [ ! -d "$TRAIN_DATA_ROOT" ]; then
  echo "Error: TRAIN_DATA_ROOT is not a path to a directory: $TRAIN_DATA_ROOT"
  echo "Set the TRAIN_DATA_ROOT variable in create_imagenet.sh to the path" \
       "where the ImageNet training data is stored."
  exit 1
fi

#if [ ! -d "$VAL_DATA_ROOT" ]; then
#  echo "Error: VAL_DATA_ROOT is not a path to a directory: $VAL_DATA_ROOT"
#  echo "Set the VAL_DATA_ROOT variable in create_imagenet.sh to the path" \
#       "where the ImageNet validation data is stored."
#  exit 1
#fi

echo "Creating train img lmdb..."
#

#rm $LMDB_PATH/ilsvrc14_train_lmdb -r
GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    $TRAIN_DATA_ROOT \
    $TRAIN_LIST_PATH/train_sal_2_png_img_shuffled.txt \
    $LMDB_PATH/ilsvrc14_train_sal_2_png_img_lmdb


echo "Creating train map lmdb..."
#rm $LMDB_PATH/ilsvrc14_train_sal_2_png_map_lmdb -r
#
GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --gray=true \
    $MAP_ROOT \
    $TRAIN_LIST_PATH/train_sal_2_png_map_shuffled.txt \
    $LMDB_PATH/ilsvrc14_train_sal_2_png_map_lmdb



#GLOG_logtostderr=1 $TOOLS/convert_imageset \
#    --resize_height=$RESIZE_HEIGHT \
#    --resize_width=$RESIZE_WIDTH \
#    --shuffle \
#    $VAL_DATA_ROOT \
#    $DATA/val.txt \
#    $EXAMPLE/ilsvrc12_val_lmdb
#
echo "Done."

#./build/tools/caffe train -solver=examples/cvpr17-sal-finetune/solver.prototxt -weights=models/cvpr17-ILT-pretrain-fs/ip-1_iter_5000.caffemodel -gpu=0,1 2>&1  | tee examples/cvpr17-sal-finetune/log-2-0.txt
#