# Lab 2 - Train the classification model

In this lab, you will train an image classification model to identify bird species.
Here are the steps involved:

1. Understand SageMaker's built in Image Classification algorithm
2. Create a SageMaker training job, including the hyperparameters
4. View the results of the training

## Understand SageMaker's Image Classification algorithm

## Create a SageMaker training job, including the hyperparameters

In this section, you will create a SageMaker training job to build your bird species identification model.  The resulting model artifacts will be used in a SageMaker endpoint to provide predictions.  Detailed documentation is available for image classification [hyperparameters](https://docs.aws.amazon.com/sagemaker/latest/dg/IC-Hyperparameter.html) as well as how to [train a model](https://docs.aws.amazon.com/sagemaker/latest/dg/IC-Hyperparameter.html) using Amazon SageMaker.

Here are the detailed steps to train the model by creating a job from the console.  First click on `Training Jobs` on the left panel of the SageMaker console.  Then click on `Create Training Job`.  From there, you need to fill in the details of the job:

* Pick a name for the job.
* Choose `Image classification` from the built in list of algorithms.
* Choose `ml.p2.xlarge` instance type.  Note that your account must have its resource limit increased beyond the default of 0.  The p2 and p3 instance families provide GPU's, which are required for SageMaker's image classification algorithm.
* Define 2 data channels.  Content type `application/x-recordio`. Compression type: None, Record wrapper type: None, Data type: S3Prefix, S3 data distribution type: FullyReplicated. URI: s3://<bucket-name>/train/ . S3 output path: s3://<bucket-name>/output .

Define the hyperparameters:
* **num_classes**: 4.  If you were to use the full NABirds dataset, this would be 555.
* **num_training_samples**: 335.  If you were to use the full NABirds dataset, this would be > 40,000.
* **epochs**: 15.  For this size dataset on the selected instance type, 15 epochs will allow the job to complete in around 6 minutes with reasonable accuracy.  If you had more time available, you could improve the accuracy by doubling the number of epochs.
* **checkpoint_frequency**: 15.
* **augmentation_type** 'crop'. This tells the algorithm to also flip each image horizontally to increase the model's ability to accurately identify species.  If a bird is facing left in the image, this augmentation will also train the model with a copy of the image with the bird facing to the right.
* **image_shape**: '3,224,224'.
* **learning_rate**: 0.1.
* **lr_scheduler_factor**: 0.1.
* **mini_batch_size**: 24.
* **num_layers**: 152.
* **optimizer**: sgd.
* **use_pretrained_model**: 0.

For all other parameters, use default values.

Click on `Create training job`, which will create the job and launch it on the selected instance type.  Note that training job creation could be accomplished from a Jupyter notebook, or from a CI/CD pipeline, or using the AWS CLI.

## View the results of the training

Click on training job to view details.

Click on `view logs`.

Pick the latest log stream.

Should see logging of progress for each epoch.  Pay attention to `Validation-accuracy`, as it should be steadily increasing.

Provide script or Jupyter notebook to view the accuracy progress by epoch.

Results are saved in `model.tar.gz` in the specified output directory.  That will be used to create a model for inference.

## Navigation

[Home](../README.md) - [Lab 1](lab1-image-prep.md) - [Lab 2](lab2-train-model.md) - [Lab 3](lab3-host-model.md) - [Lab 4](lab4-trigger-inference-from-s3.md) - [Lab 5](lab5-deeplens-detect-and-classify.md) - [Lab 6](lab6-text-notification.md) - [Troubleshooting](troubleshooting.md)
