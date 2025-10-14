<script>

    import { onMount } from "svelte";
    import { OrbitControls } from "three/examples/jsm/controls/OrbitControls.js";
    import * as THREE from "three";

    let container;

    onMount(() => {

        const floorHeight = 1.6;

        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(
            75,
            container.clientWidth / container.clientHeight,
            0.1,
            1000
        )
        const renderer = new THREE.WebGLRenderer({antialias: true});
        renderer.setSize(container.clientWidth, container.clientHeight);
        container.appendChild(renderer.domElement);

        const floor = new THREE.Mesh(
            new THREE.PlaneGeometry(20, 20),
            new THREE.MeshStandardMaterial({color:0xff0000})
        );
        // @ts-ignore
        floor.rotation.x = -Math.PI / 2;
        // @ts-ignore
        scene.add(floor);

        const box = new THREE.Mesh(
            new THREE.BoxGeometry(2, 2, 2),
            new THREE.MeshStandardMaterial({color: 0xffffff})
        );
        // @ts-ignore
        box.position.set(0, 0.5, -3)
        // @ts-ignore
        scene.add(box);

        const light = new THREE.DirectionalLight(0xffffff, 1);
        // @ts-ignore
        light.position.set(3, 5, 3);
        scene.add(light);

        // @ts-ignore
        camera.position.y = floorHeight;
        // @ts-ignore
        camera.position.z = 5;

        const velocity = new THREE.Vector3();        
        const direction = new THREE.Vector3();        
        const keys = { w: false, a: false, s: false, d: false, " ": false };

        let isDragging = false;
        let prevMouse = { x: 0, y: 0 };

        window.addEventListener("keydown", e => {
            if (keys[e.key.toLowerCase()] !== undefined) keys[e.key.toLowerCase()] = true;
        });

        window.addEventListener("keyup", e => {
            if (keys[e.key.toLowerCase()] !== undefined) keys[e.key.toLowerCase()] = false;
        });

        window.addEventListener("mousedown", e => {
            isDragging = true;
            prevMouse.x = e.clientX;
            prevMouse.y = e.clientY;
        })
        
        window.addEventListener("mouseup", () => {
            isDragging = false;
        })

        window.addEventListener("mousemove", e => {
            if (isDragging) {
                const deltaX = e.clientX - prevMouse.x;
    
                // @ts-ignore
                camera.rotation.y = deltaX / container.clientWidth * Math.PI;
            }
        })

        // const controls = new OrbitControls(camera, renderer.domElement);

        function animate() {
            requestAnimationFrame(animate);

            // @ts-ignore
            if (camera.position.y == floorHeight) {
                if (keys[" "]) {
                    velocity.y = 0.05;
                }
            } else {
                velocity.y -= 0.001;
            }
            
            // @ts-ignore
            if (camera.position.y < floorHeight) {
                velocity.y = 0;
                // @ts-ignore
                camera.position.y = floorHeight;
            }

            direction.z = Number(keys.s) - Number(keys.w);
            direction.x = Number(keys.d) - Number(keys.a);
            direction.normalize();

            const speed = 0.05;
            velocity.z = direction.z * speed;
            velocity.x = direction.x * speed;

            // @ts-ignore
            camera.position.add(velocity);

            renderer.render(scene, camera);
            // controls.update();
        }

        animate();
    });
</script>

<style>
    #scene-container {
        position: fixed;
        width: 100vw;
        height: 100vh;
        overflow: hidden;
        background-color: black;
    }
</style>

<div id="scene-container" bind:this={container}></div>
