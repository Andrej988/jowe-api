data "archive_file" "common_layer_zip" {
  type        = "zip"
  source_dir  = "${local.lambda_directories["layers_base"]}/common/"
  output_path = "./temp/common_layer.zip"
}

resource "aws_lambda_layer_version" "common_layer" {
  filename   = data.archive_file.common_layer_zip.output_path
  layer_name = "JoWe-common-layer"

  compatible_runtimes      = [local.lambda_runtimes["nodejs_common_runtime"]]

  source_code_hash = data.archive_file.common_layer_zip.output_base64sha256

  depends_on = [
    data.archive_file.common_layer_zip
  ]
}
