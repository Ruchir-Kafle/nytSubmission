<script lang="ts">

    import { onMount } from "svelte";
    import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader.js";
    import { OrbitControls } from "three/examples/jsm/controls/OrbitControls.js";
    import * as THREE from "three";

    let container;

    onMount(() => {

        const playerHeight = 1.6;

        const scene = new THREE.Scene();
        const characterCamera = new THREE.PerspectiveCamera(
            75,
            container.clientWidth / container.clientHeight,
            0.1,
            1000
        )
        const characterCameraVisual = new THREE.CameraHelper(characterCamera);
        scene.add(characterCameraVisual);
        const orbitCamera = new THREE.PerspectiveCamera(
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
        floor.rotation.x = -Math.PI / 2;
        scene.add(floor);

        const loader = new GLTFLoader();

        loader.load(
            "/assets/BASEmodel.glb",
            (gltf) => {
                const model = gltf.scene;
                model.position.set(0, 0, -3)
                scene.add(model);
            },
            (xhr) => console.log(`${(xhr.loaded / xhr.total) * 100}% loaded`),
            (error) => console.error("Error loading GLB:", error)
        );

        // const box = new THREE.Mesh(
        //     new THREE.BoxGeometry(2, 2, 2),
        //     new THREE.MeshStandardMaterial({color: 0xffffff})
        // );
        // box.position.set(0, 1, -3)
        // scene.add(box);

        const light = new THREE.DirectionalLight(0xffffff, 1);
        light.position.set(3, 5, 3);
        scene.add(light);

        characterCamera.position.y = playerHeight;
        
        characterCamera.position.z = 5;

        let orbit = false;
        const keys = { w: false, a: false, s: false, d: false };

        let isDragging = false;
        let prevMouse = { x: 0, y: 0 };

        window.addEventListener("keydown", e => {
            if (keys[e.key.toLowerCase()] !== undefined) keys[e.key.toLowerCase()] = true;
        });

        window.addEventListener("keyup", e => {
            if (keys[e.key.toLowerCase()] !== undefined) keys[e.key.toLowerCase()] = false;
            if (e.key.toLowerCase() === "j") {
                
                orbit = !orbit;

                if (orbit) {
                    orbitCamera.position.copy(characterCamera.position).add(new THREE.Vector3(5, 3, 5));
                    
                    controls.target.copy(characterCamera.position);
                    controls.update();
                }
            }

        });

        window.addEventListener("mousedown", e => {
            if (!orbit) {
                isDragging = true;
                prevMouse.x = e.clientX;
                prevMouse.y = e.clientY;
            }
        })
        
        window.addEventListener("mouseup", () => {
            isDragging = false;
        })

        window.addEventListener("mousemove", e => {
            if (isDragging) {
                const deltaX = e.clientX - prevMouse.x;
                characterCamera.rotation.y += deltaX / container.clientWidth * Math.PI;
                prevMouse.x = e.clientX;
            }
        })

        const controls = new OrbitControls(orbitCamera, renderer.domElement);
        controls.enableDamping = true;

        function animate() {
            requestAnimationFrame(animate);
            
            const right = new THREE.Vector3();
            const moveDir = new THREE.Vector3();
            
            const forward = new THREE.Vector3();
            characterCamera.getWorldDirection(forward);
            forward.y = 0;
            forward.normalize();

            right.crossVectors(forward, characterCamera.up).normalize();

            if (keys.w) moveDir.add(forward);
            if (keys.s) moveDir.add(forward.clone().multiplyScalar(-1));
            if (keys.d) moveDir.add(right);
            if (keys.a) moveDir.add(right.clone().multiplyScalar(-1));

            moveDir.normalize();
            const speed = 0.1;
            
            characterCamera.position.add(moveDir.multiplyScalar(speed));

            characterCameraVisual.visible = orbit;

            if (orbit) {
                renderer.render(scene, orbitCamera);
                controls.update();
            } else {
                renderer.render(scene, characterCamera);
            }

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
