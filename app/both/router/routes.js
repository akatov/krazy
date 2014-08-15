/*****************************************************************************/
/* Client and Server Routes */
/*****************************************************************************/
Router.configure({
  layoutTemplate: 'MasterLayout',
  loadingTemplate: 'Loading',
  notFoundTemplate: 'NotFound',
  templateNameConverter: 'upperCamelCase',
  routeControllerNameConverter: 'upperCamelCase'
});

Router.onBeforeAction(function(){
  if (!Meteor.userId()) {
    Router.go('index')
  }
}, {only: ['boards.show']})

Router.map(function () {
  this.route('index', {path: '/'});
  this.route('boards.show', {path: '/boards/:_id'});
});
