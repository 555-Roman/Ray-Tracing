#version 330 core

out vec4 FragColor;

in vec2 windowPos;

struct Ray {
	vec3 origin;
	vec3 dir;
};

struct Sphere {
	vec3 center;
	float radius;
	vec3 color;
};

struct HitInfo {
	bool didHit;
	float dist;
	vec3 hitPos;
	vec3 normal;
	vec3 color;
};

float aspectRatio = 800.0 / 600.0;
float focalLength = 1.0;
float viewportHeight = 2.0;
float viewportWidth = viewportHeight * aspectRatio;
vec3 cameraCenter = vec3(0.0);

vec3 viewportU = vec3(viewportWidth, 0.0, 0.0);
vec3 viewportV = vec3(0.0, -viewportHeight, 0.0);

vec3 pixelDeltaU = viewportU / 800.0;
vec3 pixelDeltaV = viewportV / 600.0;

vec3 viewportUpperLeft = cameraCenter - vec3(0.0, 0.0, focalLength) - viewportU/2 - viewportV/2;
vec3 pixel00Loc = viewportUpperLeft + .5 * (pixelDeltaU + pixelDeltaV);

HitInfo intersectSphere(Ray ray, Sphere sphere) {
	HitInfo hitInfo;
	hitInfo.didHit = false;
	
	vec3 co = ray.origin - sphere.center;
	float a = dot(ray.dir, ray.dir); //(a = 1)
    float b = 2 * dot(co, ray.dir);
    float c = dot(co, co) - sphere.radius * sphere.radius;
    float discriminant = b * b - 4 * a * c; // b^2-4ac
	if (discriminant >= 0.0) {
		float dist = (-b - sqrt(discriminant)) / 2;

		if (dist >= 0.0) {
			hitInfo.didHit = true;
            hitInfo.dist = dist;
            hitInfo.hitPos = ray.origin + (ray.dir * dist);
            hitInfo.normal = normalize(hitInfo.hitPos - sphere.center);
			hitInfo.color = sphere.color;
		}
	}

	return hitInfo;
}

void main() {
	vec3 pixelCenter = pixel00Loc + (windowPos.x * pixelDeltaU) + (windowPos.y * pixelDeltaV);
	vec3 rayDirection = pixelCenter - cameraCenter;
	Ray ray = {cameraCenter, rayDirection};

	Sphere sphere = {vec3(0.0, 0.0, -1.0), 0.5, vec3(1.0, 0.0, 0.0)};
	HitInfo hitInfo = intersectSphere(ray, sphere);
	if (hitInfo.didHit) {
		float diffuse = max(0.0, dot(hitInfo.normal, normalize(vec3(-1.0, 2.0, 1.0))));

		FragColor = vec4(hitInfo.color * (diffuse+0.2), 1.0);
	} else {
		vec3 unitDir = normalize(ray.dir);
		float a = .5 * (unitDir.y + 1.0);
		FragColor = vec4((1.0-a)*vec3(1.0, 1.0, 1.0) + a*vec3(0.5, 0.7, 1.0), 1.0);
	}
}