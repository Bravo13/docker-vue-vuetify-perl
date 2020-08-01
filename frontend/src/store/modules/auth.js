const state = {
    authorized: false,
    token: ''
}

const getters = {
    isAuthorized(state) {
        return state.authorized;
    },

    getAuthToken(state) {
        return state.token;
    }
}

const actions = {

}

const mutations = {
    setAuthToken(state, token) {
        state.authorized  = true;
        state.token = token;
    },

    unAuthorize(state) {
        state.isAuthorized = false;
        state.token = '';
    }
}

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}