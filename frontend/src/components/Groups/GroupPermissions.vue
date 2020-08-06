<template>
        <tr>
            <td>{{group.name}}</td>
            <td v-for="permission in permissions" v-bind:key="permission.name">
                <v-switch
                    v-model="hasPermissions[permission.name]"
                    v-on:change="save()"
                ></v-switch>
            </td>
        </tr>
</template>
<script>
import {mapActions} from 'vuex';
export default {
    props: ['group', 'permissions'],
    data: function() {
        return {
            loading: true,
            hasPermissions: {}
        }
    },
    methods: {
        ...mapActions(['call']),
        save: function() {
            const permissions = Object.keys(this.hasPermissions).filter((p) => this.hasPermissions[p]);
            this.call({
                url:'/group/permissions/set',
                data: {
                    name: this.group.name,
                    permissions: permissions
                }
            }).then((response) => {
                if(response.data.success){
                    this.$dialog.message.success('Saved');
                } else {
                    this.$dialog.message.warnings('Unknown status');
                }
            })
        },
        getPermissions: function() {
            this.call({
                url:'/group/permissions/list',
                data:{
                    name: this.group.name
                }
            }).then((response)=>{
                this.hasPermissions = Object.fromEntries(response.data.permissions.map((p)=>[p.name, true]));
                this.loading = false;
            })
        }
    },
    mounted: function() {
        this.getPermissions();
    }
}
</script>