Para o correto funcionamento é necessário

-AWSCLI
-NUCLEI
-NOTIFY

Alterar o conteúdo do index.html para o que quiserem.

chmod +x awssubdomaintakeover.sh

Single
awssubdomaintakeover.sh dominio

Massive
cat dominiosaws | xargs -I@ sh -c 'awssubdomaintakeover @'
