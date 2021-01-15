


process  echoing{
  input:
  val num from Channel.of(1..20)

  output:

  file "*.txt" into result

  script:
  """
  echo $num > ${num}.txt
  """
}

result
.collectFile(sort: true,storeDir:"outs")
