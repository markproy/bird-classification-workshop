python im2rec.py --list --recursive --train-ratio 0.75 nabirds_sample2 ../images/
python im2rec.py --resize 256 nabirds_sample2 ../images/

aws s3 cp nabirds_sample2_train.rec s3://<bucket>/nabirds_sample2_train.rec
