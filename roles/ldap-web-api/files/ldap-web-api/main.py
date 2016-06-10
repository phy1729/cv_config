#!/usr/bin/env python

from flask import Flask, render_template
import ldap
from datetime import timedelta
from flask import make_response, request, current_app
from functools import update_wrapper


def crossdomain(origin=None, methods=None, headers=None,
		max_age=21600, attach_to_all=True,
		automatic_options=True):
    if methods is not None:
	methods = ', '.join(sorted(x.upper() for x in methods))
    if headers is not None and not isinstance(headers, basestring):
	headers = ', '.join(x.upper() for x in headers)
    if not isinstance(origin, basestring):
	origin = ', '.join(origin)
    if isinstance(max_age, timedelta):
	max_age = max_age.total_seconds()

    def get_methods():
	if methods is not None:
	    return methods

	options_resp = current_app.make_default_options_response()
	return options_resp.headers['allow']

    def decorator(f):
	def wrapped_function(*args, **kwargs):
	    if automatic_options and request.method == 'OPTIONS':
		resp = current_app.make_default_options_response()
	    else:
		resp = make_response(f(*args, **kwargs))
	    if not attach_to_all and request.method != 'OPTIONS':
		return resp

	    h = resp.headers

	    h['Access-Control-Allow-Origin'] = origin
	    h['Access-Control-Allow-Methods'] = get_methods()
	    h['Access-Control-Max-Age'] = str(max_age)
	    if headers is not None:
		h['Access-Control-Allow-Headers'] = headers
	    return resp

	f.provide_automatic_options = False
	return update_wrapper(wrapped_function, f)
    return decorator

app = Flask(__name__)
app.debug = False

@app.route("/")
def index():
    return ""

def version():
    return "CV Restful Ldap - Version 0.0.1"


@app.route("/<uid>/<field>")
@crossdomain(origin='*')
def ldapQuery(uid, field):
    return str(getLdap(uid,field))


@app.route("/<uid>/<field>/<element>")
@crossdomain(origin='*')
def ldapQueryElement(uid, field, element):
    return str(getLdap(uid,field)[int(element)])

def getLdap(uid, field):
    try:
	l = ldap.initialize("ldap://ldap.collegiumv.org")
	l.simple_bind_s()
	result = l.search_s("ou=people,dc=collegiumv,dc=org", ldap.SCOPE_SUBTREE, "(uid={0})".format(uid), attrlist=[str(field)])
	l.unbind()
	if len(result) == 0:
	    return "No user found"
	return result[0][1].itervalues().next()
    except ldap.LDAPError, e:
	return "An error occurred: %s" % e
    except Exception as e:
	print e

if __name__ == "__main__":
    host = "localhost"
    port = 7291
    app.run(host, port)
