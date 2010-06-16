package TermStream::Web::Controller::Root;
use Moose;
use namespace::autoclean;
use Data::UUID::LibUUID;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

TermStream::Web::Controller::Root - Root Controller for TermStream::Web

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    require YAML;
    $c->session->{id} ||= new_uuid_string();

    $c->stash->{template} = 'foo.tt';
    $c->forward( $c->view('TT') );

    # Hello World
    #$c->response->body( $c->welcome_message );
    #$c->response->body($html);
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
