data "archive_file" "masterdata_shared_layer_zip" {
  type        = "zip"
  source_dir  = "${local.lambda_directories["layers_base"]}/masterdata/shared/"
  output_path = "./temp/masterdata_shared_layer.zip"
}

resource "aws_lambda_layer_version" "masterdata_shared_layer" {
  filename   = data.archive_file.masterdata_shared_layer_zip.output_path
  layer_name = "JoWe-masterdata-shared-layer"

  compatible_runtimes = [local.lambda_runtimes["nodejs_common_runtime"]]

  source_code_hash = data.archive_file.masterdata_shared_layer_zip.output_base64sha256

  depends_on = [
    data.archive_file.masterdata_shared_layer_zip
  ]
}
