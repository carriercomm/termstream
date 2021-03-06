package TermStream::Web;
use Moose;
use namespace::autoclean;
use KiokuDB;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
    Authentication
    Session
    Session::State::Cookie
    Session::Store::KiokuDB
/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

# Configure the application.
#
# Note that settings in termstream_web.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config({

    name => 'TermStream::Web',

    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,

    'Plugin::Authentication' => {
        realms => {
            default => {
                credential => {
                    class         => 'Password',
                    password_type => 'self_check',
                },
                store => {
                    class      => 'Model::KiokuDB',
                    model_name => 'kiokudb',
                },
            },
        },
    },

    root => __PACKAGE__->path_to('root'),

    default_view => 'TT',

    'View::TT' => {
        INCLUDE_PATH       => [
            __PACKAGE__->path_to('root', 'tt'),
        ],
        TEMPLATE_EXTENSION => '.tt',
        CATALYST_VAR       => 'c',
        TIMER              => 0,
        #PRE_PROCESS        => 'config/main', # I don't know what this means
        WRAPPER            => 'wrapper/main.tt',
        render_die         => 1,
    },
});

__PACKAGE__->config->{session}{kiokuObject} = KiokuDB->connect('bdb:dir=root/db');
__PACKAGE__->config->{session}{kiokuScope}
    = __PACKAGE__->config->{session}{kiokuObject}->new_scope;

# Start the application
__PACKAGE__->setup();


=head1 NAME

TermStream::Web - Catalyst based application

=head1 SYNOPSIS

    script/termstream_web_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<TermStream::Web::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
