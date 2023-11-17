output "lambda_role" {
  value = aws_iam_role.lambda_role
  description = "The full role information"
}

output "lambda_name" {
  value = aws_lambda_function.function.function_name
  description = "The name of the function"
}

output "lambda_arn" {
  value = aws_lambda_function.function.arn
  description = "The ARN of the function"
}

output "lambda_log_group_name" {
  value = aws_cloudwatch_log_group.log_group.name
  description = "The name of the log group"
}