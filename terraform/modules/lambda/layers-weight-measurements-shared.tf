data "archive_file" "weight_shared_layer_zip" {
  type        = "zip"
  source_dir  = "${local.lambda_layers_directory_base}/weight/shared/"
  output_path = "./temp/measurements_shared_layer.zip"
}

resource "aws_lambda_layer_version" "weight_shared_layer" {
  filename   = data.archive_file.weight_shared_layer_zip.output_path
  layer_name = "JoWe-weight-measurements-shared-layer"

  compatible_runtimes = [local.lambdas_common_runtime]

  source_code_hash = data.archive_file.weight_shared_layer_zip.output_base64sha256

  depends_on = [
    data.archive_file.weight_shared_layer_zip
  ]
}
