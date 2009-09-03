#
# MediaURLs -- A plugin to allow the use of separate URLs for media assets
# 
# Copyright (c) 2009 Scott Boms
# <http://www.scottboms.com/>
#

# Thursday 3 September 2009

# ---------------------------------------------------------------------------
# The MIT License 
# http://www.opensource.org/licenses/mit-license.php
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# ---------------------------------------------------------------------------

package MT::Plugin::MediaURLs;
use strict;
use warnings;

use base qw( MT::Plugin );
use MT::Template::Context;
use MT::Util qw( rtrim );
use vars qw($VERSION);
our $VERSION = '1.0.1';

my $plugin = MT::Plugin::MediaURLs->new({
  id => 'mediaurls',
  name => 'MediaURLs',
  description => 'Adds the ability to define special media URLs for external resources such as Javascript, CSS and images to help optimize site performance as per the Yahoo! site optimization guidelines.',
  doc_link => 'http://github.com/scottboms/mt-mediaurls',
  author_name => 'Scott Boms',
  author_link => 'http://www.scottboms.com',
  icon => 'mu-icon.gif',
  version => $VERSION,
  settings => new MT::PluginSettings([
    ['js_url', { Default => '', Scope => 'system' }],
    ['images_url', { Default => '', Scope => 'system' }],
    ['css_url', { Default => '', Scope => 'system' }],
    ['media_url', { Default => '', Scope => 'system' }],
  ]),
  system_config_template => 'config.tmpl',
});

MT->add_plugin($plugin);

sub init_registry {
  my $plugin = shift;
  $plugin->registry({
    tags => {
      function => {
        'JsUrl' => \&get_js_url,
        'ImagesUrl' => \&get_images_url,
        'CssUrl' => \&get_css_url,
        'MediaUrl' => \&get_media_url,
      },
    },
  });
}

sub get_js_url {
  my $plugin = MT->component("MediaURLs");
  my $js_url = $plugin->get_config_value('js_url','system');
}

sub get_images_url {
  my $plugin = MT->component("MediaURLs");
  my $images_url = $plugin->get_config_value('images_url','system');
}

sub get_css_url {
  my $plugin = MT->component("MediaURLs");
  my $css_url = $plugin->get_config_value('css_url','system');
}

sub get_media_url {
  my $plugin = MT->component("MediaURLs");
  my $css_url = $plugin->get_config_value('media_url','system');
}

# ---------------------------------------------------------------------------
# Settings - Load, Save, Reset
# Can be set at the user level
# ---------------------------------------------------------------------------
sub load_config {
  my $plugin = shift;
  my $app = MT->instance;
  return unless $app->can('user');

  my ($param, $scope) = @_;
  $scope .= ':user:' . $app->user->id if $scope =~ m/^blog:/;
  $plugin->SUPER::load_config($param, $scope);
}

sub save_config {
  my $plugin = shift;
  my $app = MT->instance;
  return unless $app->can('user');

  my ($param, $scope) = @_;
  $scope .= ':user:' . $app->user->id if $scope =~ m/^blog:/;
  $plugin->SUPER::save_config($param, $scope);
}

sub reset_config {
  my $plugin = shift;
  my $app = MT->instance;
  return unless $app->can('user');

  my ($param, $scope) = @_;
  $scope .= ':user:' . $app->user->id if $scope =~ m/^blog:/;
  $plugin->SUPER::reset_config($scope);
}