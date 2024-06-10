variable "vpc_id" {
  type = string
}

variable "public_cidrs" {
  type = list(string)
}

variable "webSGid" {
  type = string
}

variable "webSBids" {
  type = list(string)
}