<template>
    <v-navigation-drawer
        expand-on-hover
        mini-variant
        permanent
        app
    >
        <v-list
            dense
            nav
            class="py-0"
        >
            <v-list-item two-line class='px-0'>
                <v-list-item-avatar>
                    <img src="https://randomuser.me/api/portraits/men/81.jpg">
                </v-list-item-avatar>
                <v-list-item-content>
                    <v-list-item-title>
                        Title here
                    </v-list-item-title>
                    <v-list-item-subtitle>
                        Subtitle
                    </v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>

            <v-divider></v-divider>

            <v-list-item
                v-for="item in items"
                :key="item.title"
                link
            >
                <v-list-item-icon>
                    <v-icon>{{ item.icon }}</v-icon>
                </v-list-item-icon>

                <v-list-item-content>
                    <v-list-item-title>
                        <router-link v-bind:to="item.route">
                            {{ item.title }}
                        </router-link>
                    </v-list-item-title>
                </v-list-item-content>
            </v-list-item>
        </v-list>
    </v-navigation-drawer>
</template>

<script>
export default {
    data() {
        return {
            items: [
                {
                    title: "Dashboard",
                    icon: "mdi-group",
                    route: "/"
                }, {
                    title: "Groups and permissions",
                    icon: "mdi-group",
                    route: "/groups"
                }
            ]
        }
    }
}
</script>