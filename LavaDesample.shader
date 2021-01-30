// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Anil/Amplify Lava Desample"
{
	Properties
	{
		_Tiling("Tiling", Vector) = (0.5,0.5,0,0)
		[HDR]_Color("Color", Color) = (1.416203,0.82602,0.4742946,0)
		_Scale("Scale", Float) = 9
		_Speed("Speed", Float) = 0
		[Toggle]_ToggleSwitch0("Toggle Switch0", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma surface surf Standard keepalpha noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform half4 _Color;
		uniform half _ToggleSwitch0;
		uniform half2 _Tiling;
		uniform half _Speed;
		uniform half _Scale;

		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			half simplePerlin2D50 = 1;

			if(_ToggleSwitch0 == 1) // for performance toggle on and of via code
			{
				half2 break58 = half2( 0.1,0.1 );
				half mulTime52 = _Time.y * _Speed;
				half2 appendResult60 = (half2(break58.x , ( break58.y * mulTime52 )));
				float2 uv_TexCoord19 = i.uv_texcoord * _Tiling + appendResult60;
				simplePerlin2D50 = snoise( uv_TexCoord19*_Scale );
				simplePerlin2D50 = simplePerlin2D50 * 0.5 + 0.5;
			}
			
			o.Emission = ( _Color * simplePerlin2D50).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}