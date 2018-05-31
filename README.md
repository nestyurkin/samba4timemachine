# samba4timemachine
Latest Samba Server for support OSX High Sierra 


Based on Alpine Edge
OSX High Sierra needs Samba server >= 4.8.0 


## Simple ansible config example

```
    - name: create avahi config
      copy: src=samba.service dest="/etc/avahi/services/samba.service"
      tags:
        - samba

    - name: Restart service avahi
      tags:
        - samba
      service:
        name: avahi-daemon
        state: restarted

    - name: create samba config
      copy: src=smb.conf dest="{{docker_dir}}/samba/smb.conf"
      tags:
        - samba

    - name: samba container
      tags:
        - docker
        - samba
      docker_container:
        name: samba
        image: nestyurkin/samba4timemachine
        pull: yes     
        restart_policy: always  
        volumes:
          - "{{share_dir}}/timemachine/nikn:/srv/tm-nikn"
          - "{{share_dir}}/timemachine/anna:/srv/tm-anna"
          - "{{share_dir}}/shared:/srv/shared"
          - "{{docker_dir}}/samba/smb.conf:/etc/samba/smb.conf"
        network_mode: host
        env:
          TZ: Europe/Moscow
          USERID: 922
          GROUPID: 922
        command:
          - -u "nikn;pass1"
          - -u "anna;pass2"
```