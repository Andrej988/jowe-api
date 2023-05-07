data "archive_file" "weight_measurements_shared_layer_zip" {
  type        = "zip"
  source_dir  = "./lambdas/layers/weight/measurements/shared/"
  output_path = "./temp/measurements_shared_layer.zip"
}

resource "aws_lambda_layer_version" "weight_measurements_shared_layer" {
  filename   = data.archive_file.weight_measurements_shared_layer_zip.output_path
  layer_name = "JoWe-weight-measurements-shared-layer"

  compatible_runtimes = ["nodejs18.x"]

  source_code_hash = data.archive_file.weight_measurements_shared_layer_zip.output_base64sha256

  depends_on = [
    data.archive_file.weight_measurements_shared_layer_zip
  ]
}
