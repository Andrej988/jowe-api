data "archive_file" "common_layer_zip" {
  type        = "zip"
  source_dir  = "./lambdas/layers/common/"
  output_path = "./temp/common_layer.zip"
}

resource "aws_lambda_layer_version" "common_layer" {
  filename   = data.archive_file.common_layer_zip.output_path
  layer_name = "JoWe-common-layer"

  compatible_runtimes = ["nodejs18.x"]

  source_code_hash = data.archive_file.common_layer_zip.output_base64sha256

  depends_on = [
    data.archive_file.common_layer_zip
  ]
}
