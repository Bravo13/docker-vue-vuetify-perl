<template>
    <div>
        <h2>GROUPS</h2>
        <v-skeleton-loader
            :loading="headerLoading && rowsLoading"
            type="table"
        >
            <v-data-table
                :headers="headers"
                :items="groups"
            >
                <template v-slot:item="{item}">
                    <GroupPermissions v-bind:group="item" v-bind:permissions="permissions">
                    </GroupPermissions>
                </template>
            </v-data-table>
        </v-skeleton-loader>
    </div>
</template>

<script>
import {mapActions} from 'vuex';
import GroupPermissions from '@/components/Groups/GroupPermissions'
export default {
    data: function() {
        return {
            headerLoading: true,
            rowsLoading: true,
            headers: [],
            groups: [],
            permissions: [],
        }
    },
    methods: {
        ...mapActions(['call']),
        getTableHeader: function() {
            return this.call({url:'/permissions/list'})
                .then( (response) => {
                    this.permissions = response.data.permissions;
                    let headers = [];
                    headers.push({
                        text: "Name",
                        value: "name"
                    });
                    this.permissions.map( (permission) => headers.push({text: permission.name, value: permission.name}));
                    this.headers = headers;
                    this.headerLoading = false;
                })
        },

        getGroups: function() {
            return this.call({url:'/groups/list'})
                .then((response) => {
                    this.groups = response.data.groups;
                    this.rowsLoading = false;
                });
        }
    },
    mounted: function() {
        this.getTableHeader();
        this.getGroups();
    },
    components:{
        GroupPermissions
    }
}
</script>