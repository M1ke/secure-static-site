data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/rewrite.js"
  output_path = "${path.module}/rewrite.zip"
}

resource "aws_lambda_function" "rewrite" {
  filename = "${data.archive_file.init.output_path}"
  function_name = "static-website-rewrite--${random_id.suffix.hex}"
  role = "${aws_iam_role.static-website-lambda.arn}"
  handler = "rewrite.handler"
  source_code_hash = "${data.archive_file.init.output_base64sha256}"
  runtime = "nodejs8.10"
  publish = true
}

output "lambda_arn" {
  value = "${aws_lambda_function.rewrite.arn}:${element(concat(aws_lambda_function.rewrite.*.version, list("")),0)}"
}
