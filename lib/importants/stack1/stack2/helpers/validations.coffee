Helpers.isEmail = (email)->
  reg = /^\w+[\+\.\w-]*@([\w-]+\.)*\w+[\w-]*\.([a-z]{2,4}|\d+)$/i
#  reg1= /^[0-9A-Za-z]+[0-9A-Za-z_]*@[\w\d.]+.\w{2,4}$/
  reg.test(email)

Helpers.randomBarcode = (prefix="0", length=10)->
  for i in [0...length]
    prefix += Math.floor(Math.random() * 10)

  prefix