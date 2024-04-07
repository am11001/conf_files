# Comments

- ## bash-solution 

    run as sudo in ubuntu linux 

    for accesability add `[Your-IP] wordpress.local drupal.wordpress.local` in your hosts file

    all recuired conf files script will download from git 

    notification part is writen with curl is making post reqest to [webhook](https://webhook.site/) webiste is possible to makee different ways ,  als using corl make authenticated requests depends from where need to be done request 

    db configurations are manual , for that you need to write credentials for this sql fiel [init.sql](https://raw.githubusercontent.com/am11001/conf_files/files/init.sql)

    ### suggested improvements 

    - shellcheck 
    - makeing code more clean with variable and make it reusabele, 
    - changing script for clean after complition 
    - write script with coding best practices
    - use `.env` files and variables for secrets

- ## container-solution 

    used docker compose 

    for accesability add `[Your-IP] wordpress.local drupal.wordpress.local` in your hosts file

    for run `docker-compose up -d`

    running can take little bit longer to initilize 

    docker compose need to be run same directory with config folder nginx.conf inside

    wordpress db dont need ot be configured 

    drupal db need to beconfigured , I havent deleted env vars from drupal block for configure after running 

    same as podman just need to be run as root for be possible expose external port 

    ### suggested improvements 

    - depends from case task can be done in different ways 
    - makeing code more clean with variable and make it reusabele, add coments dfor user
    - write script with coding best practices
    - use `.env` files and variables for secrets, 

- ## ansible-solution

    run as sudo in ubuntu linux 

    for accesability add `[Your-IP] wordpress.local drupal.wordpress.local` in your hosts file

    all recuired conf files script will download from git 

    db configurations are manual , for that you need to write credentials for this sql fiel [init.sql](https://raw.githubusercontent.com/am11001/conf_files/files/init.sql)

    ### suggested improvements 

    - use variables 
    - structurize code 
    - improve code (remove unnecessary things)
    - write playbook with coding best practices
    - use `.env` files and variables for secrets


- `- Какой иной инструмент вы бы использовали для выполнения задачи и почему?` - for similar task (there is not tough requirnomets) simple tools is better , but depends from task, what is required can be chnaged code be optimised, ex. can be creted Docker file for custum docker image 
- `- Как можно упростить выполнение задач или оптимизировать их, используя другие инструменты?` - is possible with using modules, CI/CD tools, version controling tools , and monitoring for find possible errors easly


### all required files are in folders regarding by name 