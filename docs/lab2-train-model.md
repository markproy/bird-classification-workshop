# Lab 2 - Train the classification model

In this lab, you will train an image classification model to identify bird species.
Here are the steps involved:

1. Understand SageMaker's built in Image Classification algorithm
2. Create a SageMaker training job
4. View the results of the training

## Understand SageMaker's Image Classification algorithm

TBS

## Create a SageMaker training job

In this section, you will create a SageMaker training job to build your bird species identification model.  The resulting model artifacts will be used in a SageMaker endpoint to provide predictions.  Detailed documentation is available for image classification [hyperparameters](https://docs.aws.amazon.com/sagemaker/latest/dg/IC-Hyperparameter.html) as well as how to [train a model](https://docs.aws.amazon.com/sagemaker/latest/dg/IC-Hyperparameter.html) using Amazon SageMaker.

The following figure illustrates at a high level the training process.

![](./screenshots/training_the_model.png)

### Create the job from the SageMaker console

Here are the detailed steps to train the model by creating a job from the console.  First click on `Training Jobs` on the left panel of the SageMaker console.  Then click on `Create Training Job`.  From there, you need to fill in the details of the job:

* Pick a name for the job.  For example `birds`.
* Leave the IAM role as the default (something like `AmazonSageMaker-ExecutionRole-20180926T21970`).
* Choose `Image classification` from the built in list of algorithms.
* Choose `ml.p3.2xlarge` instance type.  Note that your account must have its resource limit increased beyond the default of 0.  The p2 and p3 instance families provide GPU's, which are required for SageMaker's image classification algorithm.
* Leave the Encryption key as `No Custom Encryption`.
* Leave the Maximum runtime as the default of 24 hours.
* Leave the Network as `No VPC`.

Define the hyperparameters:
* **num_classes**: 4.  If you were to use the full NABirds dataset, this would be 555.
* **num_training_samples**: 322.  If you were to use the full NABirds dataset, this would be > 40,000.
* **epochs**: 15.  For this size dataset on the selected instance type, 15 epochs will allow the job to complete in around 6 minutes with reasonable accuracy.  If you had more time available, you could improve the accuracy by doubling the number of epochs.
* **checkpoint_frequency**: 15.
* **augmentation_type** 'crop'. This tells the algorithm to also flip each image horizontally to increase the model's ability to accurately identify species.  If a bird is facing left in the image, this augmentation will also train the model with a copy of the image with the bird facing to the right.
* **mini_batch_size**: 24.
* **top_k**: 2.

For all other parameters, use default values, including:

* **image_shape**: '3,224,224'.
* **learning_rate**: 0.1.
* **lr_scheduler_factor**: 0.1.
* **num_layers**: 152.
* **optimizer**: sgd.
* **use_pretrained_model**: 0.

Define 2 data channels to tell SageMaker where to find your packaged image files from Lab 1:

* `train` for training data, with an `S3 location` of `s3://<bucket-name>/train/` (be sure to replace `<bucket-name>` with the name of your S3 bucket).  To add the second channel, click on `Add channel` below the first channel.
* `validation` for validation data, with an `S3 location` of `s3://<bucket-name>/validation/` (be sure to replace `<bucket-name>` with the name of your S3 bucket).

For each channel, use the following settings:

* Content type as `application/x-recordio`.
* Compression type: `None`.
* Record wrapper type: `None`.
* Data type: `S3Prefix`.
* S3 data distribution type: `FullyReplicated`.
* URI: `s3://<bucket-name>/train/`, replacing `<bucket-name>` with the name of your S3 bucket.

For `S3 output path`, use `s3://<bucket-name>/`, replacing `<bucket-name>` with the name of your S3 bucket.  This is the base path of the place where SageMaker will place the resulting model artifacts for the trained image classification model.  Under this base path, SageMaker will create a folder with the same name you provided for the training job, and under that it will create an `output` folder.  The artifacts will be in a file named `model.tar.gz`, and it will be used by the inference engine hosted by the SageMaker endpoint that you will create in [Lab 3](lab3-host-model.md).

Once all of your parameters for the job have been entered, click `Create training job`.  If your training job fails for any reason, you can easily `Clone` the training job, making any necessary changes before finally clicking `Create training job` for the new job.

### Other mechanisms for creating trained models using SageMaker

In the prior section, you created a training job from the SageMaker console by eventually clicking `Create training job`.  Note that you can train models using SageMaker from a Jupyter notebook, or from a CI/CD pipeline, or using the AWS CLI as well.

## View the results of the training

* Click on training job to view details.
* Click on `View logs` in the `Monitoring` section towards the bottom of the page of job details.  Note that it could take a couple of minutes before the job is executing and the log files are available for viewing.
* Pick the latest log stream.
* You will see logging of progress for each epoch of the training job.  Pay attention to `Validation-accuracy`, as it should be steadily increasing.  If you had more time available, you could significantly increase the number of epochs and see additional accuracy improvements.

**Provide script or Jupyter notebook to view the accuracy progress by epoch.**

As stated earlier, the training model artifacts are saved in `model.tar.gz` in the specified output directory.  Navigate to the S3 console, and drill down into your S3 bucket to find the model artifacts.  That file will be used to create a model for inference.

## Navigation

Go to the [Next Lab](lab3-host-model.md)

[Home](../README.md) - [Lab 1](lab1-image-prep.md) - [Lab 2](lab2-train-model.md) - [Lab 3](lab3-host-model.md) - [Lab 4](lab4-trigger-inference-from-s3.md) - [Lab 5](lab5-deeplens-detect-and-classify.md) - [Lab 6](lab6-text-notification.md) - [Troubleshooting](troubleshooting.md)
