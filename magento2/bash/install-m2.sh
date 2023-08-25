install-m2()
{

    version=$1
    path=$2

    if [[ "$1" -eq "0" ]]; then
        version='2.3.5'
    fi

    if [[ "$2" -eq "0" ]]; then
        path='./'
    fi

    command composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=$version $path

}