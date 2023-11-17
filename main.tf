data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = local.role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}


resource "aws_lambda_function" "function" {
  function_name    = var.name
  handler          = "main"
  runtime          = "provided.al2"
  role             = aws_iam_role.lambda_role.arn
  filename         = local.function_code_path
  source_code_hash = filebase64sha256(local.function_code_path)
  memory_size      = var.memory_size
  layers           = local.layers

  architectures = ["arm64"]
  tags          = local.tags
  environment {
    variables = var.environment_vars
  }

  // we setup the lambda but we do not manage it
  // it will be managed by a cd pipeline
  lifecycle {
    ignore_changes = [
      source_code_hash,
      filename
    ]
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${aws_lambda_function.function.function_name}"
  retention_in_days = 7
}
