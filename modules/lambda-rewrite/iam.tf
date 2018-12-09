# Suffix names to avoid collisions
resource "random_id" "suffix" {
  byte_length = 8
}

resource "aws_iam_role" "static-website-lambda" {
  name = "static-website-lambda-${random_id.suffix.hex}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "allow-logging" {
  name = "allow-logging-${random_id.suffix.hex}"
  path = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "allow-logging" {
  name = "allow-logging-${random_id.suffix.hex}"
  policy_arn = "${aws_iam_policy.allow-logging.arn}"
  roles = ["${aws_iam_role.static-website-lambda.name}"]
}
