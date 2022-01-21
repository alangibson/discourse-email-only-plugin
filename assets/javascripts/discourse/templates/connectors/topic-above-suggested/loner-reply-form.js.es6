export default {
  actions: {
    lonerReply() {

      const createParams = {
        email: this.get('email'),
        topic_id: this.get('model.id'),
        notification_level: 3, // 'watch' level
        body: this.get('body'),
        captcha_response: typeof grecaptcha !== 'undefined' ? grecaptcha.getResponse() : ""
      };

      const watchRecord = this.store.createRecord('watch', {
        id: Date.now(),
        content: createParams
      });

      watchRecord.save()
        .then(result => {
          console.debug(result.target);

          // TODO show success message

          // Clear form
          this.set('email', '');
          this.set('body', '');

        })
        .catch(error => {
          console.error(error);

          // TODO show error message

        });

    }
  }
};