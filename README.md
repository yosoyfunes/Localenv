# Entorno para desarrollos locales

## Getting started

```bash
docker run --rm -ti -w /data -e AWS_PROFILE=default -v ~/.aws:/root/.aws/ -v ${PWD}:/data yosoyfunes/cbff-local
```

**En este repo se tiene plasmado la mayoria de la infra necesaria para trabajar con un Cluster de EKS y los demas recursos necesarios**

Para un entorno inmutable se usa una Imagen Docker con los tools necesarios para operar:
- Linux/4.15.0-58-generic
- aws-cli/1.18.168 
- Python/2.7.17 & Python/3.7.5
- botocore/1.19.8
- terrafom 0.13.0
- kubectl ~> 1.19
- Helm3
- Stern (for Logs Kubernetes)
- Apache Maven 3.6.3
- openjdk version "11.0.9.1" 
- TruffleHog

Se toman los puertos del Host para dar servicio:

- tcp:5005 -> Debugging de Quarkus
- tcp:8080 -> Acceso desde el browser

## Prerrequisito para Mac y Linux:

- Docker for [Linux](https://docs.docker.com/engine/install/ubuntu/)
- Docker for [Mac](https://docs.docker.com/docker-for-mac/install/)

## Prerrequisito para quienes tienen Windows:

- Docker for [Windows](https://docs.docker.com/docker-for-windows/install/)
- Git for Windows, podes descargarlo de [aqui](https://gitforwindows.org/)

## Instalacion
- `git clone git@github.com:yosoyfunes/Localenv.git $HOME/Localenv`
- agregar el `PATH` según sistema operativo:

### Mac & Linux

```bash
# bash
export PATH="$PATH:$HOME/Localenv" >> ~/.bashrc

# zsh
export PATH="$PATH:$HOME/Localenv" >> ~/.zshrc
```

### Windows

```bash
# abrir powershell como administrador
setx /M path "%path%;$HOME\Localenv"
```

## Actualización
- `cd $HOME/Localenv`
- `git pull origin master`

## Tunnel SSH
- Copiar el archivo **cbff_key_name** dentro de la carpeta **Localenv/secret**

## Login para Kubectl y CodeArtifact
- Loguearte en AWS y pegar tus credenciales dentro de la carpeta **Localenv/.aws/credentials**

## Comandos utiles

|  Commando  |  Descripcion  |
|  -------  |  -----------  |
|**./cbff up**  |    Inicia el contenedor y configura variables |
|**./cbff start**  |    Prende el contenedor |
|**./cbff stop**  |    Apaga el contenedor |
|**./cbff destroy**  |    Elimina el contenedor |
|**./cbff ssh**  |    Acceso dentro del contenedor |
|**./cbff status**  |    Verifica el estado del contenedor |
|**./cbff port**  |    Muestra los puertos asignados a cada servicio |
|**./cbff dev**  |    Acceso al entorno Dev con variable AWS seteada |
|**./cbff sandbox**  |    Acceso al entorno sandbox con variable AWS seteada |
|**./cbff tunnel**  |    Genera el Tunnel al Bastion |
|**./cbff login**  |    Accede a aws (precondicion: tener actualizado el archivo . |aws/credentials)         
|**./cbff compile**  |    Ejecuta el mvn con quarkus:dev |

## Para poder acceder al Cluster de EKS se debe correr:
```shell script
aws eks --region us-east-1 update-kubeconfig --name <cluster-name> --alias <cluster-name-alias>
```
