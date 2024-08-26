# Proyecto Devops 2024


Este proyecto tiene como idea principal poner en práctica lo aprendido a través de un laboratorio que permita integrar diferentes herramientas y tecnologías. Realizando un especial foco en implementar herramientas de `CI/CD`, en esta oportunidad `Jenkins` y `Git Hub Actions`.

Durante la  primera parte nos centramos en la creación y configuración de una instancia de `EC2` en AWS para poder desde allí realizar todas las tareas
necesarias. En cada carpeta encontrarás archivos `txt` que te explicarán los pasos a seguir.

Como segunda etapa, generamos un clúster de Kubernetes `EKS` implementando `EKSCTL` (herramienta oficial de AWS, para crear y gestionar clústers).


Finalmente, con el stack de `Prometheus` y `Grafana`, realizamos el monitoreo del estado y el uso de recursos de los nodos de nuestro `EKS` generado.



![arquitectura](img/bannerFinal.jpg)

## Contenido del proyecto

1. Crear y configurar instancia `EC2`

2. Configurar instancia y `cliente aws`

3. Crear clúster con `eksctl`

4. Configurar `kubectl`

5. `Github Actions`

6. `Jenkins`

9. Herramientas de monitoreo: `Grafana`, `K9S`, `Prometheus`
