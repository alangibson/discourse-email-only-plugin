export default Ember.Controller.extend({
    init() {
        this._super();
    },

    actions: {

        watch(content) {
            if (!content) {
                return;
            }

            const watchRecord = this.store.createRecord('watch', {
                id: Date.now(),
                content: content
            });

            watchRecord.save()
                .then(result => {
                    console.debug(result.target);
                })
                .catch(console.error);
        }

    }

});