provider "aws" {
  region = "us-east-1"
}

data "aws_lambda_function" "lambda_pedido" {
  function_name = "lambda_pagamento_pedido"
}

resource "aws_sqs_queue" "my_queue" {
  name = "sqs_atualiza_pagamento_pedido"
}

resource "aws_lambda_permission" "allow_sqs" {
  statement_id  = "AllowSQSTrigger"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.lambda_pedido.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = aws_sqs_queue.my_queue.arn
}

resource "aws_lambda_event_source_mapping" "sqs_to_lambda" {
  event_source_arn = aws_sqs_queue.my_queue.arn
  function_name    = data.aws_lambda_function.lambda_pedido.arn
  batch_size       = 10
  enabled          = true
}
