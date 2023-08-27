data "archive_file" "meal_shared_layer_zip" {
  type        = "zip"
  source_dir  = "${local.lambda_directories["layers_base"]}/meal/shared/"
  output_path = "./temp/meal_shared_layer.zip"
}

resource "aws_lambda_layer_version" "meal_shared_layer" {
  filename   = data.archive_file.meal_shared_layer_zip.output_path
  layer_name = "JoWe-meal-shared-layer"

  compatible_runtimes = [local.lambda_runtimes["nodejs_common_runtime"]]

  source_code_hash = data.archive_file.meal_shared_layer_zip.output_base64sha256

  depends_on = [
    data.archive_file.meal_shared_layer_zip
  ]
}
